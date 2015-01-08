===============================================
OAuth2 provider for the Flow framework
===============================================

This is a fork of the `Kyoki.OAuth2 <https://github.com/farconada/Kyoki.OAuth2>`_ package.

This is a Flow package that provides a OAuth 2 provider, you could use it for example to enable access
to your Flow Application APIs by third party clients (i.e. Mobile clients) without tell username/password to the app

`OAuth2 Reference <http://oauth.net/2/>`_

SetUp step by step
---------------------------

1. Install the Kyoki.OAuth2 package in Flow
    Copy tne package inside Flow/Packages/Applications::

	    cd /var/www/Flow/Packages/Applications
	    git clone git://github.com/farconada/Kyoki.OAuth2.git
	    cd /var/www/Flow
   	    ./flow doctrine:update


2. SetUp you Flow config file configurations/Settings.yaml
	::

		TYPO3:
		  Flow:
		    security:
		       enable: TRUE
		       authentication:
		         authenticationStrategy: atLeastOneToken
		         providers:
		           # your DefaultProvider
		           DefaultProvider:
		             provider: PersistedUsernamePasswordProvider
		             entryPoint: 'WebRedirect'
		             entryPointOptions:
		               uri: '/login'
		             requestPatterns:
		              # a regexp pattern to disable the DefaultProvider in every Controller for every package named ApiController or TokenController
		              # It could be a better regexp of your own
		              # TokenController belongs to the Kyoki.OAuth2 package
		              # ApiController (or any other controller) is the controller securized by an OAuth access token
		               controllerObjectName: '(?!.*(Api|Token)Controller).*'
		           OAuthTokenProvider:
		             provider: Kyoki\OAuth2\Security\Authentication\Provider\AccessTokenProvider
		             token: Kyoki\OAuth2\Security\Authentication\Token\AccessTokenHttpBasic
		             requestPatterns:
			       # ApiController (or any other controller) is the controller securized by an OAuth access token
		               controllerObjectName: Acme\Demoapp\Controller\ApiController
		                 entryPoint: HttpBasic
		                 entryPointOptions:
               		           realm: 'OAuth2 Access Token Authentication'


3. There are routes defined in Kyoki.OAuth2 for /authorize and /token

4. Ensure that the authenticateAction in you package redirects to requested url after successfuly login
	for example::
	
		public function authenticateAction() {
		
				try {
					$this->authenticationManager->authenticate();
				} catch (\TYPO3\Flow\Security\Exception\AuthenticationRequiredException $exception) {
					$this->flashMessageContainer->addMessage(new \TYPO3\Flow\Error\Message('Wrong username or password.'));
					$this->redirect('login');
				}
				if ($interceptedRequest = $this->securityContext->getInterceptedRequest()) {
					$this->redirect($interceptedRequest->getControllerActionName(),
						$interceptedRequest->getControllerName(),
						$interceptedRequest->getControllerPackageKey(),
						$interceptedRequest->getArguments());
				} else {
					$this->redirect('index');
				}
		
		}


5. Create a controller and protect it with a Policy.yaml
	There are 2 roles:
	
	  * **OAuth** this role is declared in the Kyoki.OAuth2 package and allows to request tokens
	  * **myscope (or the name that you want)** this role should match a OAuthScope identifier and need to be asigned to the user to be able to access the API resources protected by OAuth tokens::
	
		resources:
		  methods:
		    Acme_Demoapp_Api: 'method(Acme\Demoapp\Controller\ApiController->.*Action())'
		roles:
		  myscope: []
		  User: [OAuth,myscope]
		acls:
		  User:
		    methods:
		      Acme_Demoapp_Api: GRANT
		  myscope:
		    methods:
      	      	      Acme_Demoapp_Api: GRANT

6. Create the required domain objects: Accounts, OAuthClient and OAuthScope
	**OAuthClient**: is an API it could be owned by the user itself or by other user, for example the API owner. The redirectUri property in the OAuthClient defines the beginning part of the URL that must match with the URL from you are querying the API. The account associated is important also cause you are identified as this account when you request a new Token with /token action
	
	**OAuthScope**: when someone request access permission it sends a scope in the parameters, this scope must match a role name defined in Policy.yaml and defines the permissions of this scope.

Notes
----------

* There is a Acme.Demoapp package inside the directory Tests/lamp/
* You can deploy a new virtualbox with vagrant with a fully Flow installation with OAuth configured
* There is an exmple OAuth client/consumer in inside the directory Tests/lamp/client




 






<?php
namespace Kyoki\OAuth2\Security\Authentication\Token;
use TYPO3\Flow\Annotations as Flow;

/*                                                                        *
 * This script belongs to the Kyoki.OAuth2 package.                        *
 * @author Fernando Arconada <fernando.arconada@gmail.com>                *
 *
 * It is free software; you can redistribute it and/or modify it under    *
 * the terms of the GNU Lesser General Public License, either version 3   *
 * of the License, or (at your option) any later version.                 *
 *                                                                        *
 *                                                                        */

/**
 * An authentication token used for simple username and password authentication via HTTP Basic Auth.
 *
 */
class AccessTokenHttpBasic extends ClientIdSecret {

	/**
	 * The username/password credentials
	 * @var array
	 * @Flow\Transient
	 */
	protected $credentials = array('access_token' => '');

	/**
	 * @var $oauthToken \Kyoki\OAuth2\Domain\Model\OAuthToken
	 */
	protected $oauthToken = NULL;

	/**
	 * Updates the username and password credentials from the HTTP authorization header.
	 * Sets the authentication status to AUTHENTICATION_NEEDED, if the header has been
	 * sent, to NO_CREDENTIALS_GIVEN if no authorization header was there.
	 *
	 * @param \TYPO3\Flow\Mvc\ActionRequest $actionRequest The current action request instance
	 * @return void
	 */
	public function updateCredentials(\TYPO3\Flow\Mvc\ActionRequest $actionRequest) {
		$authorizationHeader = $actionRequest->getHttpRequest()->getHeaders()->get('Authorization');
		$authType = substr($authorizationHeader, 0, 5);
		if ($authType === 'OAuth' or $authType === 'Basic') {
			$this->credentials['access_token'] = trim(substr($authorizationHeader, 6));
			$this->setAuthenticationStatus(self::AUTHENTICATION_NEEDED);
		} else {
			$this->credentials = array('access_token' => NULL);
			$this->authenticationStatus = self::NO_CREDENTIALS_GIVEN;
		}
	}

	/**
	 * Returns a string representation of the token for logging purposes.
	 *
	 * @return string The access token credential
	 */
	public function  __toString() {
		return 'Access Token: "' . $this->credentials['access_token'] . '"';
	}

	/**
	 * @param \Kyoki\OAuth2\Domain\Model\OAuthToken $oauthToken
	 */
	public function setOauthToken($oauthToken) {
		$this->oauthToken = $oauthToken;
	}

	/**
	 * @return \Kyoki\OAuth2\Domain\Model\OAuthToken
	 */
	public function getOauthToken() {
		return $this->oauthToken;
	}

}

?>

const String merchLogIn = r"""
query merchLogin($email: String, $username: String, $pNumber: String, $password: String!, $fcmToken: String!) {
  merch_login(
    email: $email, 
    username: $username, 
    pNumber: $pNumber, 
    password: $password, 
    fcmToken: $fcmToken
  ) {
    accessToken,
    email,
    merchId,
    staffId,
    country,
    pNumber,
    fullName,
    username,
    permissions,
    profileImgUrl
  }
}
""";

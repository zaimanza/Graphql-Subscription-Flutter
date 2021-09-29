const String merchLogIn = r"""
mutation add_channel($name: String!) {
  addChannel(
    name: $name
  ) {
    id,
    name,
  }
}
""";

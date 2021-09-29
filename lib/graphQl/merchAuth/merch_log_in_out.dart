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

const String channelAdded = r"""
subscription channel_added($name: String!) {
  channelAdded(
    name: $name
  ) {
    id,
    name,
  }
}
""";

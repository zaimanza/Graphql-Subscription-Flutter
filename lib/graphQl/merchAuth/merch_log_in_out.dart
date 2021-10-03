const String addChannel = r"""
mutation IdMutation($addChannelName: String!) {
  addChannel(name: $addChannelName) {
    id
    name
  }
}
""";

const String channelAdded = r"""
subscription channelAdded ($name: String!) {
    channelAdded (name: $name) {
        id,
        name,
    }
}
""";

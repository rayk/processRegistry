library sharedMessageKeys;

/// These are keys for all messages send around the system. Only Include the
/// are needed. Messages are processed based upon this keys so be consistent in their use.
/// The payloads will can be nested.
///
/// Contain your message in a map with these keys. Don't use the same key more then
/// once in your message.
enum Msg{
  /// Date and time the message was dispatched from the sender.
  DateTime,
  /// If the message is part of a group, a unique group ID attached.
  GroupId,
  /// Contains True if the message is an error. Don't use false if it is a not a error.
  isError,
  /// Contains True if the message is a request. Don't use false if it is not a request.
  isRequest,
  /// Contains True if the message is a response to a request. Don't use false if it is not a response.
  isResponse,
  /// A unique ID for the message, evey message has one.
  MsgId,
  /// A message payload in JSON format. Don't include if payload is not in Json Format
  PayloadJson,
  /// A message payload in the form of a list. Don't include if payload is not a list
  PayloadList,
  /// A message payload in the form of a Map with Enumerated Keys. Don't include if payload is no a Map.
  PayloadMap,
  /// Priority weight, the lower the number the higher the priority.
  PriorityWeight,
  /// A Send Port that the message should be sent to.
  ReplyTo,
  /// A common name of the sender.
  Sender,
  /// If the message is part of a group, the sequence indicates the order.
  SequenceId,
  /// TrxId are shared to be bring together a group of request and responses
  TrxId,
}
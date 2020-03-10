package robotlbrary

import (
	"container/list"
	"encoding/base64"
	"encoding/json"
	"kefu_server/models"

	msg "github.com/Xiaomi-mimc/mimc-go-sdk/message"
)

// MsgHandler ...
type MsgHandler struct {
	appAccount string
}

// NewMsgHandler ...
func NewMsgHandler(appAccount string) *MsgHandler {
	return &MsgHandler{appAccount}
}

// HandleMessage ...
func (c MsgHandler) HandleMessage(packets *list.List) {
	for ele := packets.Front(); ele != nil; ele = ele.Next() {

		// 收到的原始消息
		p2pMsg := ele.Value.(*msg.P2PMessage)

		// get message
		var message models.Message
		msgContentByte, err := base64.StdEncoding.DecodeString(string(p2pMsg.Payload()))
		err = json.Unmarshal(msgContentByte, &message)

		switch message.BizType {
		// 消息入库
		case "into":
			return
		// 撤销消息
		case "cancel":
			return
		// 搜索知识库
		case "search_knowledge":
			return
		// 与机器人握手
		case "handshake":
			return
		default:

		}

		if err == nil {
			MessageP2P(message)
		}

	}

}

// HandleGroupMessage 下面可以自己去实现一些东西（顾名思义MIMC接口）
func (c MsgHandler) HandleGroupMessage(packets *list.List) {
	//for ele := packets.Front(); ele != nil; ele = ele.Next() {
	//	p2tmsg := ele.Value.(*msg.P2TMessage)
	//	logger.Info("[%v] [handle p2t msg]%v  -> %v: %v, pcktId: %v, timestamp: %v.", c.appAccount, *(p2tmsg.FromAccount()), *(p2tmsg.GroupId()), string(p2tmsg.Payload()), *(p2tmsg.PacketId()), *(p2tmsg.Timestamp()))
	//}
}

// HandleServerAck ...
func (c MsgHandler) HandleServerAck(packetID *string, sequence, timestamp *int64, errMsg *string) {
	//logs.Info("[%v] [handle server ack] packetId:%v, seqId: %v, timestamp:%v.", c.appAccount, *packetId, *sequence, *timestamp)
}

// HandleSendMessageTimeout ...
func (c MsgHandler) HandleSendMessageTimeout(message *msg.P2PMessage) {
	//logs.Info("[%v] [handle p2pmsg timeout] packetId:%v, msg:%v, time: %v.", c.appAccount, *(message.PacketId()), string(message.Payload()), time.Now())
}

// HandleSendGroupMessageTimeout ...
func (c MsgHandler) HandleSendGroupMessageTimeout(message *msg.P2TMessage) {
	// logger.Info("[%v] [handle p2tmsg timeout] packetId:%v, msg:%v.", c.appAccount, *(message.PacketId()), string(message.Payload()))
}

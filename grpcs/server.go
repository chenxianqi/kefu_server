package grpcs

import (
	context "context"
	"encoding/base64"
	"kefu_server/models"
	"kefu_server/services"
	"kefu_server/utils"
	"log"
	"net"

	"github.com/astaxie/beego/logs"
	grpc "google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

// kefuServer
type kefuServer struct{}

// GetOnlineAllRobots
func (s *kefuServer) GetOnlineAllRobots(ctx context.Context, in *Request) (*Respones, error) {
	// query
	robots, _ := services.GetRobotRepositoryInstance().GetRobotOnlineAll()
	return &Respones{Data: utils.InterfaceToString(robots)}, nil
}

// PushMessage
func (s *kefuServer) PushMessage(ctx context.Context, in *Request) (*Respones, error) {
	var message models.Message
	msgContent, _ := base64.StdEncoding.DecodeString(in.Data)
	utils.StringToInterface(string(msgContent), &message)
	utils.MessageInto(message, false)
	return &Respones{Data: "push success"}, nil
}

// CancelMessage
func (s *kefuServer) CancelMessage(ctx context.Context, in *Request) (*Respones, error) {
	var request models.RemoveMessageRequestDto
	utils.StringToInterface(in.Data, &request)
	// cancel
	messageRepository := services.GetMessageRepositoryInstance()
	_, err := messageRepository.Delete(request)
	logs.Info("messageRepository== ", request)
	if err != nil {
		logs.Info("grpc CancelMessage err == ", err)
	}
	return &Respones{Data: "cancel message success"}, nil
}

// Run run grpc server
func Run() {
	lis, err := net.Listen("tcp", ":8028")
	if err != nil {
		log.Fatalf("grpc server failed: %v", err)
	}
	s := grpc.NewServer()
	RegisterKefuServer(s, &kefuServer{})
	reflection.Register(s)
	err = s.Serve(lis)
	if err != nil {
		logs.Info("failed to serve: ", err)
	}
}

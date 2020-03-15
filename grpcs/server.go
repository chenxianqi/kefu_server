package grpcs

import (
	context "context"
	"encoding/base64"
	"encoding/json"
	"kefu_server/models"
	"kefu_server/services"
	"kefu_server/utils"
	"net"
	"strconv"

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

// InsertMessage
func (s *kefuServer) InsertMessage(ctx context.Context, in *Request) (*Respones, error) {
	var message models.Message
	msgContent, _ := base64.StdEncoding.DecodeString(in.Data)
	utils.StringToInterface(string(msgContent), &message)
	utils.MessageInto(message)
	return &Respones{Data: "push success"}, nil
}

// CancelMessage
func (s *kefuServer) CancelMessage(ctx context.Context, in *Request) (*Respones, error) {
	var request models.RemoveMessageRequestDto
	utils.StringToInterface(in.Data, &request)
	// cancel
	messageRepository := services.GetMessageRepositoryInstance()
	_, err := messageRepository.Delete(request)
	if err != nil {
		logs.Info("grpc CancelMessage err == ", err)
	}
	return &Respones{Data: "cancel message success"}, nil
}

// SearchKnowledgeTitles
func (s *kefuServer) SearchKnowledgeTitles(ctx context.Context, in *Request) (*Respones, error) {
	var request models.KnowledgeBaseTitleRequestDto
	utils.StringToInterface(in.Data, &request)
	knowledgeBaseRepository := services.GetKnowledgeBaseRepositoryInstance()
	titles := knowledgeBaseRepository.SearchKnowledgeTitles(request)
	return &Respones{Data: utils.InterfaceToString(titles)}, nil
}

// GetOnlineAdmins
func (s *kefuServer) GetOnlineAdmins(ctx context.Context, in *Request) (*Respones, error) {
	adminRepository := services.GetAdminRepositoryInstance()
	admins := adminRepository.GetOnlineAdmins()
	return &Respones{Data: utils.InterfaceToString(admins)}, nil
}

// PushNewContacts
func (s *kefuServer) PushNewContacts(ctx context.Context, in *Request) (*Respones, error) {
	uid, _ := strconv.ParseInt(in.Data, 10, 64)
	utils.PushNewContacts(uid)
	return &Respones{Data: "PushNewContacts success"}, nil
}

// InsertStatistical
func (s *kefuServer) InsertStatistical(ctx context.Context, in *Request) (*Respones, error) {
	var servicesStatistical models.ServicesStatistical
	utils.StringToInterface(in.Data, &servicesStatistical)
	statisticalRepository := services.GetStatisticalRepositoryInstance()
	_, err := statisticalRepository.Add(&servicesStatistical)
	if err != nil {
		logs.Info("InsertStatistical err == ", err)
	}
	return &Respones{Data: "insert success"}, nil
}

// GetKnowledgeBaseWithTitle
func (s *kefuServer) GetKnowledgeBaseWithTitleAndPlatform(ctx context.Context, in *Request) (*Respones, error) {
	request := make(map[string]string)
	json.Unmarshal([]byte(in.Data), &request)
	knowledgeBaseRepository := services.GetKnowledgeBaseRepositoryInstance()
	platform, _ := strconv.ParseInt(request["platform"], 10, 64)
	knowledgeBase := knowledgeBaseRepository.GetKnowledgeBaseWithTitleAndPlatform(request["title"], platform)
	return &Respones{Data: utils.InterfaceToString(knowledgeBase)}, nil
}

// Run run grpc server
func Run() {
	lis, err := net.Listen("tcp", ":8028")
	if err != nil {
		logs.Info("grpc server failed: %v", err)
	}
	s := grpc.NewServer()
	RegisterKefuServer(s, &kefuServer{})
	reflection.Register(s)
	err = s.Serve(lis)
	if err != nil {
		logs.Info("failed to serve: ", err)
	}

}

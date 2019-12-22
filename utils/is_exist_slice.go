package utils

// InExistInSlice 检查内容是否在slice中存在
func InExistInSlice(input string, slice []string) bool {
	for _, v := range slice {
		if v == input {
			return true
		}
	}
	return false
}

package utils

// InExistInSlice Check if content exists in slice
func InExistInSlice(input string, slice []string) bool {
	for _, v := range slice {
		if v == input {
			return true
		}
	}
	return false
}

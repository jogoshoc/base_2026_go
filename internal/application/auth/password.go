package auth

import (
	"golang.org/x/crypto/bcrypt"
)

const bcryptCost = 10

// HashPassword gera um hash bcrypt da senha
func HashPassword(password string) (string, error) {
	bytes, err := bcrypt.GenerateFromPassword([]byte(password), bcryptCost)
	if err != nil {
		return "", err
	}
	return string(bytes), nil
}

// CheckPassword verifica se a senha corresponde ao hash bcrypt
// Retorna true se a senha for valida
func CheckPassword(password, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	return err == nil
}

// IsBcryptHash verifica se a string parece um hash bcrypt
func IsBcryptHash(hash string) bool {
	return len(hash) == 60 && hash[:4] == "$2a$"
}

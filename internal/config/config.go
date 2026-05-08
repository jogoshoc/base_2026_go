package config

import (
	"os"
	"strconv"
	"time"
)

type Config struct {
	Server   ServerConfig
	Database DatabaseConfig
	Session  SessionConfig
	Admin    AdminConfig
}

type ServerConfig struct {
	Port string
	Host string
}

type DatabaseConfig struct {
	Host     string
	Port     int
	User     string
	Password string
	Database string
}

func (d DatabaseConfig) DSN() string {
	return d.User + ":" + d.Password + "@tcp(" + d.Host + ":" + strconv.Itoa(d.Port) + ")/" + d.Database + "?parseTime=true"
}

type SessionConfig struct {
	Timeout time.Duration
	CookieName string
}

type AdminConfig struct {
	UserID string
}

func Load() *Config {
	port := getEnv("SERVER_PORT", "8081")
	host := getEnv("SERVER_HOST", "0.0.0.0")

	sessionTimeout := getEnvDuration("SESSION_TIMEOUT", 20*time.Minute)
	cookieName := getEnv("SESSION_COOKIE_NAME", "CGDocSession")

	adminUserID := getEnv("ADMIN_USER_ID", "1088608")

	return &Config{
		Server: ServerConfig{
			Port: port,
			Host: host,
		},
		Database: DatabaseConfig{
			Host:     getEnv("DB_HOST", "localhost"),
			Port:     getEnvInt("DB_PORT", 3306),
			User:     getEnv("DB_USER", "root"),
			Password: getEnv("DB_PASSWORD", ""),
			Database: getEnv("DB_NAME", "cgdoc"),
		},
		Session: SessionConfig{
			Timeout:   sessionTimeout,
			CookieName: cookieName,
		},
		Admin: AdminConfig{
			UserID: adminUserID,
		},
	}
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}

func getEnvInt(key string, defaultValue int) int {
	if value := os.Getenv(key); value != "" {
		if intValue, err := strconv.Atoi(value); err == nil {
			return intValue
		}
	}
	return defaultValue
}

func getEnvDuration(key string, defaultValue time.Duration) time.Duration {
	if value := os.Getenv(key); value != "" {
		if duration, err := time.ParseDuration(value); err == nil {
			return duration
		}
	}
	return defaultValue
}
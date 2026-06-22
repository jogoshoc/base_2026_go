package templates

import (
	"html/template"
	"io/ioutil"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"sync"
)

var (
	tmpl *template.Template
	once sync.Once
)

// RenderData holds common data passed to all templates.
type RenderData struct {
	Title           string
	Subsystem       string
	User            *UserData
	ActiveMenu      string
	ErrorMsg        string
	SuccessMsg      string
	ContentTemplate string // Name of the content template to render inside base.html
}

// UserData holds user info for template rendering.
type UserData struct {
	Nome       string
	NrUsuario  string
	Privilegio string
}

func getTemplatesDir() string {
	return filepath.Join("internal", "interfaces", "http", "templates")
}

// ParseTemplates recursively parses all HTML templates into memory.
// Called once at startup. Supports subdirectories (e.g. cadastro/).
func ParseTemplates() error {
	var err error
	once.Do(func() {
		dir := getTemplatesDir()
		t := template.New("")
		err = filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}
			if info.IsDir() || !strings.HasSuffix(info.Name(), ".html") {
				return nil
			}
			content, readErr := ioutil.ReadFile(path)
			if readErr != nil {
				return readErr
			}
			// Use the filename (without extension) as the template name
			name := strings.TrimSuffix(info.Name(), ".html")
			_, parseErr := t.New(name).Parse(string(content))
			return parseErr
		})
		if err != nil {
			return
		}
		tmpl = t
	})
	return err
}

// Render executes a page template inside base.html.
// The page template should define ContentTemplate (e.g. "login-content", "menu-content")
// and base.html will render it via {{template .ContentTemplate .}}.
func Render(w http.ResponseWriter, pageTemplate string, data *RenderData) {
	if tmpl == nil {
		http.Error(w, "templates not initialized", http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	if err := tmpl.ExecuteTemplate(w, pageTemplate, data); err != nil {
		http.Error(w, "template error: "+err.Error(), http.StatusInternalServerError)
	}
}

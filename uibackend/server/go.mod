module github.com/openclarity/openclarity/uibackend/server

go 1.23.2

require (
	github.com/Portshift/go-utils v0.0.0-20220421083203-89265d8a6487
	github.com/getkin/kin-openapi v0.127.0
	github.com/go-viper/mapstructure/v2 v2.1.0
	github.com/google/go-cmp v0.6.0
	github.com/labstack/echo/v4 v4.13.3
	github.com/oapi-codegen/echo-middleware v1.0.2
	github.com/oapi-codegen/oapi-codegen/v2 v2.3.1-0.20240915195924-0502e95d86bb
	github.com/oapi-codegen/runtime v1.1.1
	github.com/onsi/gomega v1.35.1
	github.com/openclarity/openclarity/api/client v1.1.3
	github.com/openclarity/openclarity/api/types v1.1.3
	github.com/openclarity/openclarity/core v1.1.3
	github.com/openclarity/openclarity/scanner v1.1.3
	github.com/openclarity/openclarity/uibackend/types v1.1.3
	github.com/sirupsen/logrus v1.9.3
	github.com/spf13/cobra v1.8.1
	github.com/spf13/viper v1.19.0
	gotest.tools/v3 v3.5.1
)

require (
	github.com/apapsch/go-jsonmerge/v2 v2.0.0 // indirect
	github.com/dprotaso/go-yit v0.0.0-20220510233725-9ba8df137936 // indirect
	github.com/fsnotify/fsnotify v1.7.0 // indirect
	github.com/go-openapi/jsonpointer v0.21.0 // indirect
	github.com/go-openapi/swag v0.23.0 // indirect
	github.com/google/uuid v1.6.0 // indirect
	github.com/gorilla/mux v1.8.1 // indirect
	github.com/hashicorp/hcl v1.0.0 // indirect
	github.com/inconshreveable/mousetrap v1.1.0 // indirect
	github.com/invopop/yaml v0.3.1 // indirect
	github.com/josharian/intern v1.0.0 // indirect
	github.com/labstack/gommon v0.4.2 // indirect
	github.com/magiconair/properties v1.8.7 // indirect
	github.com/mailru/easyjson v0.7.7 // indirect
	github.com/mattn/go-colorable v0.1.13 // indirect
	github.com/mattn/go-isatty v0.0.20 // indirect
	github.com/mitchellh/mapstructure v1.5.0 // indirect
	github.com/mohae/deepcopy v0.0.0-20170929034955-c48cc78d4826 // indirect
	github.com/openclarity/openclarity/plugins/sdk-go v1.1.3 // indirect
	github.com/pelletier/go-toml/v2 v2.2.2 // indirect
	github.com/perimeterx/marshmallow v1.1.5 // indirect
	github.com/sagikazarmark/locafero v0.4.0 // indirect
	github.com/sagikazarmark/slog-shim v0.1.0 // indirect
	github.com/sourcegraph/conc v0.3.0 // indirect
	github.com/speakeasy-api/openapi-overlay v0.9.0 // indirect
	github.com/spf13/afero v1.11.0 // indirect
	github.com/spf13/cast v1.7.0 // indirect
	github.com/spf13/pflag v1.0.6 // indirect
	github.com/subosito/gotenv v1.6.0 // indirect
	github.com/valyala/bytebufferpool v1.0.0 // indirect
	github.com/valyala/fasttemplate v1.2.2 // indirect
	github.com/vmware-labs/yaml-jsonpath v0.3.2 // indirect
	go.uber.org/multierr v1.11.0 // indirect
	golang.org/x/crypto v0.32.0 // indirect
	golang.org/x/exp v0.0.0-20241217172543-b2144cdd0a67 // indirect
	golang.org/x/mod v0.22.0 // indirect
	golang.org/x/net v0.34.0 // indirect
	golang.org/x/sync v0.10.0 // indirect
	golang.org/x/sys v0.29.0 // indirect
	golang.org/x/text v0.21.0 // indirect
	golang.org/x/time v0.9.0 // indirect
	golang.org/x/tools v0.29.0 // indirect
	gopkg.in/ini.v1 v1.67.0 // indirect
	gopkg.in/yaml.v2 v2.4.0 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
)

replace (
	github.com/openclarity/openclarity/api/client => ../../api/client
	github.com/openclarity/openclarity/api/types => ../../api/types
	github.com/openclarity/openclarity/core => ../../core
	github.com/openclarity/openclarity/plugins/runner => ../../plugins/runner
	github.com/openclarity/openclarity/plugins/sdk-go => ../../plugins/sdk-go
	github.com/openclarity/openclarity/scanner => ../../scanner
	github.com/openclarity/openclarity/uibackend/types => ../types
	github.com/openclarity/openclarity/utils => ../../utils
	github.com/openclarity/openclarity/workflow => ../../workflow
)

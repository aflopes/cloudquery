package {{.Service}}

import (
	"context"

	"github.com/cloudquery/plugin-sdk/v2/schema"
	"github.com/cloudquery/plugin-sdk/v2/transformers"
	"github.com/cloudquery/cloudquery/plugins/source/stripe/client"
	"github.com/stripe/stripe-go/v74"
)

func {{.TableName | ToPascal}}() *schema.Table {
    return &schema.Table{
  		Name:        "{{.Plugin}}_{{.TableName}}",
		{{- if .Description}}
      Description: `{{.Description}}`,
    {{- end}}
      Transform:   client.TransformWithStruct(&stripe.{{.StructName}}{},
{{- if .SkipFields}}transformers.WithSkipFields({{.SkipFields | QuoteJoin}}),{{end -}}
{{- if .IgnoreInTests}}transformers.WithIgnoreInTestsTransformer(client.CreateIgnoreInTestsTransformer({{.IgnoreInTests | QuoteJoin}})),{{end -}}
				),
      Resolver:    fetch{{.TableName | ToPascal}},
{{if .HasIDPK}}
		  Columns: []schema.Column{
				 {
								 Name:     "id",
								 Type:     schema.TypeString,
								 Resolver: schema.PathResolver("ID"),
								 CreationOptions: schema.ColumnCreationOptions{
												 PrimaryKey: true,
								 },
				 },
			},
{{end}}
{{if or .Children .ExtraChildren}}
	Relations: []*schema.Table{
	{{- range .Children}}
		{{.TableName | ToPascal}}(),
	{{- end}}
	{{- range .ExtraChildren}}
		{{.}},
	{{- end}}
	},
{{end}}
    }
}

func fetch{{.TableName | ToPascal}}(ctx context.Context, meta schema.ClientMeta, parent *schema.Resource, res chan<- any) error {
		cl := meta.(*client.Client)

		val, err := cl.Services.{{.TableName | ToPascal}}.Get(&stripe.{{.TableName | ToPascal | Singularize}}Params{})
		if err != nil {
			return err
		}
		res <- val
		return nil
}

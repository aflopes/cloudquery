package storagecache

import (
	"context"

	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/storagecache/armstoragecache"
	"github.com/cloudquery/cloudquery/plugins/source/azure/client"
	"github.com/cloudquery/plugin-sdk/schema"
	"github.com/cloudquery/plugin-sdk/transformers"
)

func Caches() *schema.Table {
	return &schema.Table{
		Name:        "azure_storagecache_caches",
		Resolver:    fetchCaches,
		Description: "https://learn.microsoft.com/en-us/rest/api/storagecache/caches/list?tabs=HTTP#cache",
		Multiplex:   client.SubscriptionMultiplexRegisteredNamespace("azure_storagecache_caches", client.Namespacemicrosoft_storagecache),
		Transform:   transformers.TransformWithStruct(&armstoragecache.Cache{}),
		Columns: []schema.Column{
			{
				Name:     "subscription_id",
				Type:     schema.TypeString,
				Resolver: client.ResolveAzureSubscription,
			},
			{
				Name:     "id",
				Type:     schema.TypeString,
				Resolver: schema.PathResolver("ID"),
				CreationOptions: schema.ColumnCreationOptions{
					PrimaryKey: true,
				},
			},
		},
	}
}

func fetchCaches(ctx context.Context, meta schema.ClientMeta, parent *schema.Resource, res chan<- any) error {
	cl := meta.(*client.Client)
	svc, err := armstoragecache.NewCachesClient(cl.SubscriptionId, cl.Creds, cl.Options)
	if err != nil {
		return err
	}
	pager := svc.NewListPager(nil)
	for pager.More() {
		p, err := pager.NextPage(ctx)
		if err != nil {
			return err
		}
		res <- p.Value
	}
	return nil
}

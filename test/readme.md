
# Azure Dashboard Storage Queues Length

I was trying to show the length of Azure Storage Queues within the [Azure Portal Dashboard](https://docs.microsoft.com/en-us/azure/azure-portal/azure-portal-dashboards).
A feasible approach would be to enable [Azure Queue Storage Logs](https://docs.microsoft.com/en-us/azure/storage/queues/monitor-queue-storage-reference) and create a [Log Analytics query](https://docs.microsoft.com/en-us/azure/azure-monitor/visualize/tutorial-logs-dashboards) and use the [Log Analytics tile](https://docs.microsoft.com/en-us/azure/azure-monitor/app/tutorial-app-dashboards#add-logs-query) within the [Azure Portal Dashboard](https://docs.microsoft.com/en-us/azure/azure-portal/azure-portal-dashboards).

Well, my use case ruled out [Azure Queue Storage Logs](https://docs.microsoft.com/en-us/azure/storage/queues/monitor-queue-storage-reference) as the presented information must be up to date and log generation/log query latency disqualified this approach.

This is therefore about an alternative approach.

The [Azure Portal Dashboard](https://docs.microsoft.com/en-us/azure/azure-portal/azure-portal-dashboards) can be customized with [Markdown tiles](https://docs.microsoft.com/en-us/azure/azure-portal/azure-portal-markdown-tile).
The [Markdown tile](https://docs.microsoft.com/en-us/azure/azure-portal/azure-portal-markdown-tile) can be defined via inline markdown or point to an URL that serves markdown.

The URL points in this example to an Azure Function that queries the [Azure Storage queues](https://docs.microsoft.com/en-us/azure/storage/queues/storage-queues-introduction) and returns Markdown with the information that has to be displayed within the [Azure Portal Dashboard](https://docs.microsoft.com/en-us/azure/azure-portal/azure-portal-dashboards).

This is as easy to [setup](https://docs.microsoft.com/en-us/azure/azure-portal/azure-portal-markdown-tile) as it gets... and failed.

```
There was an issue accessing the content. Please try again.
```

The browser network debugging tools were inconclusive.
Fiddler didn't show any failures.

This puzzled me for a moment... looking at the debugging console showed the reason for this.

```
Access to XMLHttpRequest at 'https://...' from origin 'https://...' has been blocked by CORS policy:
No 'Access-Control-Allow-Origin' header is present on the requested resource.
```            

Azure Functions Node Sample code to set "Access-Control-Allow-Origin" and "Cache-Control".

```
context.res = {
    status: 200,
    headers: {
        "Content-Type": "text/plain; charset=utf-8",
        "Access-Control-Allow-Origin": "*",
        "Cache-Control": "max-age=0"
    },
    body: "#hello world"
};
```

The http request origin header `req.headers["origin"]` can be evaluated to meet the use case.<br/>Please see the documentation for [Access-Control-Allow-Origin](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Origin).

> Limiting the possible Access-Control-Allow-Origin values to a set of allowed origins requires code on the server side to check the value of the Origin request header, compare that to a list of allowed origins, and then if the Origin value is in the list, set the Access-Control-Allow-Origin value to the same value as the Origin value.

The Azure Function code meets my use case regarding security, performance, ... but I am not a 100% that this is the most straight forward way to display the Azure Storage Queue length within an Azure Portal Dashboard.

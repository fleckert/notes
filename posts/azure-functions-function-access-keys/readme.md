The [Azure Management Rest Api](https://docs.microsoft.com/en-us/rest/api/appservice/web-apps/get-function) is used to resolve the [Function access keys](https://docs.microsoft.com/en-us/azure/azure-functions/security-concepts#function-access-keys) for functions within an [Azure Function](https://docs.microsoft.com/en-us/azure/azure-functions/).

```
./getFunctionAccessKeys.sh myResourceGroupName myFunctionAppName
```

sample output

```
9WdFl5cj7qzZ/ahOzRiWdiChK23443TzysqHclKF3F6E0OgT2LE72A==    functionName_a
JvZw6s0JH5ZX2ILtrb6hhyR0D1PyFjWTl9G6rNdVaNvFUlJuKZf/PA==    functionName_b
OR5FSR5VQ1ijUy6yspy1rwfakZNE3wlnejeuubCyYL49lJyzR2COyg==    functionName_b
```

The shell script requires
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [jq](https://stedolan.github.io/jq/)
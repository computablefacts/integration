# Get-CsvFromMaterializeSql Usage

Launch the command with :

```
PS > ./Get-CsvFromMaterializeSql.ps1 -CfApiKey <your_api_key> -CfApiUrl <your_url_root>
```

You need to replace `<your_url_root>` by the root URL of your ComputableFacts website. Example: https://dev.company.computablefacts.com.

You need to replace `<your_api_key>` by a valid API key. You can create one in your ComputableFacts account settings.

By default, the command read the SQL query from the file named `query.sql`. You can choose another file by adding its name as the first parameter.

```
PS > ./Get-CsvFromMaterializeSql.ps1 my_request.txt -CfApiKey <your_api_key> -CfApiUrl <your_url_root>
```

By default, the command will get the results 100 rows for each API call. You can change this by adding the `-RowsPerPage` parameter.

```
PS > ./Get-CsvFromMaterializeSql.ps1 -RowPerPage 500 -CfApiKey <your_api_key> -CfApiUrl <your_url_root>
```

The result will be objects displayed to the screen. If you want to save the result to a file, just append `| Export-Csv -NoTypeInformation -Path my_results.csv` after the command.

If you have problems with characters encoding (such as having a `?` instead of an accentuated character like `éàè`...) check the `Export-Csv` command encoding to choose Utf8. This is the default under [Powershell 7.x](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/export-csv?view=powershell-7.1#parameters) but under [Powershell 5.1](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/export-csv?view=powershell-5.1#parameters) you must add the parameter `-Encoding utf8`.

# Apply-Migrations usage

Launch the command with :

```
PS > ./Apply-Migrations.ps1 -CfApiKey <your_api_key> -CfApiUrl <your_url_root>
```

The command execute the `up` migrations by default. If you want to execute the `down` migrations, launch :
```
PS > ./Apply-Migrations.ps1 down -CfApiKey <your_api_key> -CfApiUrl <your_url_root>
```


Your migration files should be in the `Migrations` sub-directory. If you want to change the directoyr, launch :

```
PS > ./Apply-Migrations.ps1 up MySubDirMigrations -CfApiKey <your_api_key> -CfApiUrl <your_url_root>
```

For `up` migration, the command execute all the SQL files ending by `.up.sql` found in the sub-directory in alphabetical order.

For `down` migration, the command execute all the SQL files ending by `.down.sql` found in the sub-directory in reverse alphabetical order.


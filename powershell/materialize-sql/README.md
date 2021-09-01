# Usage

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

By default, the command will get the results 10 rows for each API call. You can change this by adding the `-RowsPerPage` parameter.

```
PS > ./Get-CsvFromMaterializeSql.ps1 -RowPerPage 50 -CfApiKey <your_api_key> -CfApiUrl <your_url_root>
```

The result will be formatted as a CSV file and displayed to the screen. If you want to save the result to a file, just append `| Out-File my_results.csv` after the command.

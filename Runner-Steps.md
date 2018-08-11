# Runner Steps Guideline

You could use this command to clear cache on rails or running a rails script by specifying its path

```cucumber
And User clear cache
And User run command "Rails.cache.clear"
And User run script on "script/payment_fee.rb"
```
###Look Up Url 

it helps you to get meta-data from any url

steps:

- ``` % gem build lookupurl.gemspec ```
- ``` % gem install lookupurl-0.0.x.gem```
- done

```
% irb
> require 'lookupurl'
> l = LookUpUrl.new
> l.crawl_url("http://www.github.com")
> puts l.title #to check the title result
> puts l.description
> puts l.host
> puts l.url
> puts l.image_url
```

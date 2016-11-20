# Redmine AutoLinker

_Links issue descriptions, journal values and formatted custom fields_

Autolinker will replace patterns in linkable fields of certain models so that they link to a given URL. Match groups in the pattern can be inserted into the URL. The patterns are setup in the plugin config (Administration > Plugins > Redmine Text Autolinker > Configure).

## Creating a link

+ The expression is the regular expression that will be linked on the issue fields.
+ Don't use catch-alls like .* - they will greedily match the whole description. Instead use the non-greedy version: .*?
+ To insert part of the matched expression into the URL, capture it in a match group.
+ Each match group will be added to the URL inside the escaped section with the number of the group. For example ABC(\d+) will insert the number matched into {{ 1 }} in the URL.
+ The expression ABC(\d+) and the URL http://example.com/{{ 1 }} will link the following urls:
  + ABC123 to http://example.com/123
  + ABC8 to http://example.com/8
+ But it will not link
  + ABC 123 because it has a space. ABC ?(\d+) will allow for an optional space
  + ABC because there is no number.
  + abc321 because the regex is case sensitive.

## Extending the links

If you want to add new models that can be linked, edit `al_issue_patch.rb` and add the class and fields to the list. For example:

    [
      [Issue, :description],
      [Journal, :notes],
      [MyExtraClass, [:some_field, :another_field]]
    ]

An optional third element can be given to define a Proc that will be called with the instance of the class as an argument to determine if the field should be auto-linked. For example the `CustomValue` is only linked if it's custom field type is formatted.

    [CustomValue, :value, if: Proc.new { |this|
      this.custom_field.format_store.has_key? 'text_formatting'
    }]

# ADB SMS Sender

## Dependencies 

ADB tools(Already connected to your phone with `adb connect`)

bash environment

Nexus 6P(Only tested on my phone, you must change the tap coordinate by yourself)

## Usage

```bash
bash send.sh template.txt sample.csv
```

Please write your template to `template.txt`, and replace the name with "${MACRO1}" and "${MACRO2}".

Please write the name and phone number to `sample.csv`. Every line have three parameters: PhoneNumber MACRO1 MACRO2

Follow my sample.

## Warning

This script may cost you a large amount of money!

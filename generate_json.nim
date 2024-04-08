# Imports.
import std/[
    json,
    strutils,
    encodings,
]


# Load file from ISO-8859-1 encoding.
let 
    file = convert(readFile("usb.ids"), "UTF-8", "ISO-8859-1")
    ids = file.split("\n")

var
    data = %* {}
    curr_vendor = %* {}
    curr_vendor_key = ""


# Reading raw data.
for idx, val in ids:
    var 
        val: string = val
        item: seq[string]

    if val.strip() != "" and val[0] != '#' and val != "\n":
        if $val[0] == "\t":
            val = val[1..len(val)]
            val = val[0..len(val)-1]
            item = val.split(" ", maxsplit=2)
            curr_vendor[curr_vendor_key]["devices"][item[0]] = %* item[2]
        else:
            if curr_vendor != %* {}:
                data[curr_vendor_key] = curr_vendor
                curr_vendor = %* {}

            if val[0] == 'C':
                break

            val = val[0..len(val)-1]
            item = val.split(" ", maxsplit=2)
            curr_vendor = %* {
                "id": item[0],
                "name": item[1],
                "devices": %* {}
            }
            curr_vendor_key = item[0]


# Parse data to json file.
let resultingFile = open("result.json", fmWrite)
resultingFile.write(data)
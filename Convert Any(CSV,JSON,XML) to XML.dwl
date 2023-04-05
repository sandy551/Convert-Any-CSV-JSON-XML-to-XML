%dw 2.0
output application/xml
/*
1.it will convert the any type/structure input to xml required format.
2.output of function anyToXml is in array format.
3.anyToXml accept two arguments like - anyToXml(arg1,arg2)
  1. arg1 indicates the payload
  2. arg2 indicates the type of payload
4.after exicution of anyToXml function our values come under root->rootItems->items
*/
fun anyToXml(inbound,dataType :String):Array =(
    if(lower(inbound.^mediaType) contains "xml") "root":"rootItems" : "item"  :inbound
    else if(inbound is Object)(
        if(dataType ~= "Object")
        "root":"rootItems" : "item"  : inbound
        else
        inbound
    )
    else if(inbound is Array) (
        "root":"rootItems" : inbound map(
            "item" : if($ is Object)
                        anyToXml($,"")
                     else anyToXml($,typeOf($))
        )
    )
    else if(dataType ~= "Object")
    inbound
    else "root":"rootItems" : "item": inbound
)
---
anyToXml(payload, typeOf(payload))

# Define file locations
$edgeListFile = "edgelist.csv"
$nodeListFile = "nodelist.csv"
$graphMLFile = "graph_file.graphml"

# Write the beginning information
$beginning = @"
<?xml version="1.0" encoding="UTF-8"?>
<graphml xmlns="http://graphml.graphdrawing.org/xmlns"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://graphml.graphdrawing.org/xmlns
 http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd">
"@

# Write the attribute information
$attr1 = @"
<key id="d0" for="node" attr.name="attr" attr.type="string">
 <default>none</default>
</key>
<key id="tag" for="node" attr.name="tag" attr.type="string">
 <default>none</default>
</key>
"@

# The beginning of the graph
$graph_head = '<graph id="G" edgedefault="undirected">'

# Create and open graphML file
$graphMLContent = $beginning + $attr1 + $graph_head

# Process the nodes
Get-Content $nodeListFile | ForEach-Object {
    $linenode = $_ -split ';'
    $node = ($linenode[0] -replace '[<>]', '_').Trim()
    $tag = ($linenode[1] -replace '[<>]', '_').Trim()
    if ($node -ne "") {
        $graphMLContent += "<node id=`"$node`"><data key=`"tag`">$tag</data></node>`n"
    }
}

# Process the edges
$i = 0
Get-Content $edgeListFile | ForEach-Object {
    $line = $_ -split ';'
    $source = ($line[0] -replace '[<>]', '_').Trim()
    $target = ($line[1] -replace '[<>]', '_').Trim()
    if ($source -ne "" -and $target -ne "") {
        $edgeContent = "<edge id=`"e$i`" source=`"$source`" target=`"$target`"/>`n"
        $graphMLContent += $edgeContent
        $i++
    }
}

# Format the end and write to file
$graphMLContent += "</graph>`n</graphml>"
Set-Content -Path $graphMLFile -Value $graphMLContent
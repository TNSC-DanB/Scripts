#Get list of mailboxes
$mbx = get-mailbox
$mbx = get-mailbox "Username"
$mbx = get-adgroup "DistributionGroup" | get-adgroupmember | %{get-mailbox $_.Name}

#Search and list results
$mbx | search-mailbox -TargetMailbox AdminTargetMailbox -TargetFolder "Search Results" -SearchQuery {Subject:"Subject Text" AND Sent:"2/4/2016"} -LogOnly -LogLevel Full

#Search and delete
$mbx | search-mailbox -TargetMailbox AdminTargetMailbox -TargetFolder "Search Results" -SearchQuery {Subject:"Subject Text" AND Sent:"2/4/2016"} -LogOnly -LogLevel Full
<#

ORCA-110 Check if internal malware notification is disabled in malware policies.    

#>

using module "..\ORCA.psm1"

class ORCA110 : ORCACheck
{
    <#
    
        CONSTRUCTOR with Check Header Data
    
    #>

    ORCA110()
    {
        $this.Control="ORCA-110"
        $this.Area="Malware Filter Policy"
        $this.Name="Internal Sender Notifications"
        $this.PassText="Internal Sender notifications are disabled"
        $this.FailRecommendation="Disable notifying internal senders of malware detection"
        $this.Importance="Notifying internal senders about malware detected in email messages could have negative impact. An adversary with access to an already compromised mailbox may use this information to verify effectiveness of malware detection."
        $this.ExpandResults=$True
        $this.ItemName="Policy"
        $this.DataType="EnableInternalSenderNotifications"
        $this.Links= @{
            "Recommended settings for EOP and Office 365 ATP security"="https://docs.microsoft.com/en-us/microsoft-365/security/office-365-security/recommended-settings-for-eop-and-office365-atp#anti-spam-anti-malware-and-anti-phishing-protection-in-eop"
        }
    }

    <#
    
        RESULTS
    
    #>

    GetResults($Config)
    {
        ForEach($Policy in $Config["MalwareFilterPolicy"])
        {
            
            If ($Policy.EnableInternalSenderNotifications -eq $True)
            {
                $this.Results += New-Object -TypeName psobject -Property @{
                    Result="Fail"
                    ConfigItem=$($Policy.Name)
                    ConfigData=$($Policy.EnableInternalSenderNotifications)
                    Control=$this.Control
                }
            }
            Else
            {
                $this.Results += New-Object -TypeName psobject -Property @{
                    Result="Pass"
                    ConfigItem=$($Policy.Name)
                    ConfigData=$($Policy.EnableInternalSenderNotifications)
                    Control=$this.Control
                }
            }
        }
    }

}
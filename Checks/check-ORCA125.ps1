<#

125 Checks if EOP anti-malware Policy external sender notification is configured.

#>

using module "..\ORCA.psm1"

class ORCA125 : ORCACheck
{
    <#
    
        CONSTRUCTOR with Check Header Data
    
    #>

    ORCA125()
    {
        $this.Control=125
        $this.Area="Malware Filter Policy"
        $this.Name="External Sender Notifications"
        $this.PassText="External Sender notifications are disabled"
        $this.FailRecommendation="Disable notifying external senders of malware detection"
        $this.Importance="Notifying external senders about malware detected in email messages could have negative impact. An adversary may use this information to verify effectiveness of malware detection."
        $this.ExpandResults=$True
        $this.CheckType=[CheckType]::ObjectPropertyValue
        $this.ObjectType="Policy"
        $this.ItemName="Setting"
        $this.DataType="Current Value"
        $this.Links= @{
            "Recommended settings for EOP and Office 365 ATP security"="https://docs.microsoft.com/en-us/microsoft-365/security/office-365-security/recommended-settings-for-eop-and-office365-atp#anti-spam-anti-malware-and-anti-phishing-protection-in-eop"
            "Configure anti-malware policies"="https://docs.microsoft.com/en-us/microsoft-365/security/office-365-security/configure-anti-malware-policies"
        }
    
    }

    <#
    
        RESULTS
    
    #>

    GetResults($Config)
    {

        ForEach($Policy in $Config["MalwareFilterPolicy"]) 
        {

            # Fail if EnableExternalSenderNotifications is set to true in the policy

            If($Policy.EnableExternalSenderNotifications -eq $true) 
            {
                $this.Results += New-Object -TypeName psobject -Property @{
                    Result="Fail"
                    Object=$($Policy.Name)
                    ConfigItem="EnableExternalSenderNotifications"
                    ConfigData=$($Policy.EnableExternalSenderNotifications)
                    Control=$this.Control
                } 
            }
            Else
            {
                $this.Results += New-Object -TypeName psobject -Property @{
                    Result="Pass"
                    Object=$($Policy.Name)
                    ConfigItem="EnableExternalSenderNotifications"
                    ConfigData=$($Policy.EnableExternalSenderNotifications)
                    Control=$this.Control
                } 
            }
        }

    }

}
<#

    189
    
    Checks to determine if SafeAttachments is being bypassed by injecting X-MS-Exchange-Organization-SkipSafeAttachmentProcessing
    header in to emails using a mail flow rule.

#>

using module "..\ORCA.psm1"

class ORCA189 : ORCACheck
{
    <#
    
        CONSTRUCTOR with Check Header Data
    
    #>

    ORCA189()
    {
        $this.Control=189
        $this.Services=[ORCAService]::OATP
        $this.Area="Advanced Threat Protection Policies"
        $this.Name="Safe Attachment Whitelisting"
        $this.PassText="Safe Attachments is not bypassed"
        $this.FailRecommendation="Remove mail flow rules which bypass Safe Attachments"
        $this.Importance="Office 365 ATP Safe Attachments assists scanning for zero day malware by using behavioural analysis and sandboxing, supplementing signature definitions. The protection can be bypassed using mail flow rules which set the X-MS-Exchange-Organization-SkipSafeAttachmentProcessing header for email messages."
        $this.ExpandResults=$True
        $this.ObjectType="Transport Rule"
        $this.ItemName="Setting"
        $this.DataType="Current Value"
        $this.CheckType = [CheckType]::ObjectPropertyValue
    }

    <#
    
        RESULTS
    
    #>

    GetResults($Config)
    {

        $BypassRules = @($Config["TransportRules"] | Where-Object {$_.SetHeaderName -eq "X-MS-Exchange-Organization-SkipSafeAttachmentProcessing"})
        
        If($BypassRules.Count -gt 0) 
        {
            # Rules exist to bypass
            ForEach($Rule in $BypassRules) 
            {
                $this.Results += New-Object -TypeName psobject -Property @{
                    Result="Fail"
                    Object=$($Rule.Name)
                    ConfigItem="X-MS-Exchange-Organization-SkipSafeAttachmentProcessing"
                    ConfigData=$($Rule.SetHeaderValue)
                    Rule="SafeAttachments not bypassed"
                    Control=$this.Control
                }
            }
        } 
        Else 
        {
            # Rules do not exist to bypass
            $this.Results += New-Object -TypeName psobject -Property @{
                Result="Pass"
                ConfigItem="Transport Rules"
                Rule="SafeAttachments not bypassed"
                Control=$this.Control
            }
        }        

    }

}
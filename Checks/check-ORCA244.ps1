using module "..\ORCA.psm1"

class ORCA244 : ORCACheck
{
    <#
    
        Honor DMARC Policy
    
    #>

    ORCA244()
    {
        $this.Control=244
        $this.Services=[ORCAService]::EOP
        $this.Area="Anti-Phishing Policy"
        $this.Name="Honor DMARC Policy"
        $this.PassText="Policies are configured to honor sending domains DMARC."
        $this.FailRecommendation="Configure anti-phish policy to honor sending domains DMARC configuration."
        $this.Importance="Domain-based Message Authentication, Reporting & Conformance (DMARC) is a standard that helps prevent spoofing by verifying the senders identity. If an email fails DMARC validation, it often means that the sender is not who they claim to be, and the email could be fraudulent. The owner of the sending domain controls the DMARC policy for their domain, and provides recommendations to receivers on what action should be performed when DMARC fails. When the Honor DMARC Policy setting is set to False, the organisations policy is not considered. It is recommended to honor this policy. "
        $this.ExpandResults=$True
        $this.ItemName="Antiphishing Policy"
        $this.DataType="Honor DMARC Policy"
        $this.ChiValue=[ORCACHI]::Medium
        $this.ObjectType="Policy"
        $this.Links= @{
            "Announcing New DMARC Policy Handling Defaults for Enhanced Email Security"="https://techcommunity.microsoft.com/t5/exchange-team-blog/announcing-new-dmarc-policy-handling-defaults-for-enhanced-email/ba-p/3878883",
            "Microsoft 365 Defender Portal - Anti-phishing"="https://security.microsoft.com/antiphishing"
        }
    }

    <#
    
        RESULTS
    
    #>

    GetResults($Config)
    {


        ForEach($Policy in $Config["AntiPhishPolicy"]) 
        {
            $IsPolicyDisabled = !$Config["PolicyStates"][$Policy.Guid.ToString()].Applies

            $policyname = $Config["PolicyStates"][$Policy.Guid.ToString()].Name

            # Check objects
            $ConfigObject = [ORCACheckConfig]::new()
            $ConfigObject.ConfigItem=$policyname
            $ConfigObject.ConfigData=$($Policy.HonorDmarcPolicy)
            $ConfigObject.ConfigDisabled = $IsPolicyDisabled
            $ConfigObject.ConfigReadonly = $Policy.IsPreset
            $ConfigObject.ConfigPolicyGuid=$Policy.Guid.ToString()

            If($Policy.HonorDmarcPolicy -eq $true)  
            {
                $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Pass")
            } 
            Else 
            {
                $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Fail")
            }

            $this.AddConfig($ConfigObject)

        }

    }

}
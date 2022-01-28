//Lord of the Rings: Return of the King autosplitter by Thotht based on the one by NLM aka NextLevelMemes



state("ROTK")
{
    byte Load : 0xAAFA0, 0x178;
    byte IsCutscene : 0xEA468, 0x4;
    string5 Level : 0x7F388, 0x58E;
    uint BossHP : 0x179754, 0xAA0;
    string9 LastCutsceneName : 0x4E3EB0;
}

init
{
    refreshRate = 30;
    timer.IsGameTimePaused = false; //disabling pause after relaunching
    // List of strings to check what levels were split
    vars.levels = new List<String>();
}

start
{
    if(current.Level == "Hel01" && old.Level == "Fro03")
    {
        vars.levels.Add(current.Level);
        return true;
    }
    else return false;	
}

split
{
    if(current.Level != old.Level && current.Level != "Fro03" && !vars.levels.Contains(current.Level)) // splits on every level load from menu, that doesnt go to a level already visited
    {
        vars.levels.Add(current.Level);
        return true;
    }
    if(current.Level == "Cra01" && current.BossHP == 100 && current.IsCutscene == 0 && old.IsCutscene == 1)
    return true;
    else return false;
}

isLoading
{
    if(current.Load == 1 || current.Load == 255) // cuts out loads
    return true;
    if(current.Level == "Fro03" && (current.LastCutsceneName == "logos.avi" || current.LastCutsceneName == "")) // Cuts out Main Menu *before* a cutscene that isnt logos is loaded
    return true;
    else return false;
}

startup
{
    var errorMessage = MessageBox.Show
	(
        "If you're using software like DxWnd to play in\n"+
        "windowed mode, make sure you run the game\n"+
        "first and LiveSplit afterwards, as otherwise\n"+
	    "the autosplitter might not work at all.",
       	"RotK splitter WARNING!",
     	MessageBoxButtons.OK,
		MessageBoxIcon.Error
    );
}

exit
{
    timer.IsGameTimePaused = true; // pause on quit
}

state("Hellevator")
{
	string255 levelName: "mono-2.0-bdwgc.dll", 0x495C70, 0x650, 0x58, 0x14;
	string255 CheckpointToLoad: "mono-2.0-bdwgc.dll", 0x495C70, 0x650, 0x30, 0x14;
	bool InDialogue: "mono-2.0-bdwgc.dll", 0x493DE8, 0x68, 0xe08, 0x220, 0x51;
	bool CurrentDemonCanMove: "mono-2.0-bdwgc.dll", 0x493de8, 0x68, 0xe08, 0x220, 0x20, 0xcb;
	bool LoadingLevel: "mono-2.0-bdwgc.dll", 0x495C70, 0x650, 0x78;
	int CollectibleTally: "mono-2.0-bdwgc.dll", 0x498F58, 0x1e0, 0x20, 0x1a0, 0x30, 0x50; //The number does not seen to reset on new game
}

startup
{
	vars.firstElevatorDialogue = false;
	vars.secondElevatorDialogue = false;
	settings.Add("Splits");
	settings.CurrentDefaultParent = "Splits";
	
	settings.Add("Tutorial Exit");
	settings.SetToolTip("Tutorial Exit", "Splits on leaving the elevator.");
	
	settings.Add("Storage Exit");
	settings.SetToolTip("Storage Exit", "Splits on leaving the room with the blue blocks that crush you from the sides.");
	
	settings.Add("Kitchen Entry");
	settings.SetToolTip("Kitchen Entry", "Splits on entering the first room of the kitchen.");
	
	settings.Add("Beelzbub Start");
	settings.SetToolTip("Beelzbub Start", "Splits on entering the boss room");
	
	settings.Add("Beelzbub End");
	settings.SetToolTip("Beelzbub End", "Splits on grabbing the boss key.");
	
	settings.Add("Lifeguard Start");
	settings.SetToolTip("Lifeguard Start", "Splits on entering the boss room");
	
	settings.Add("Lifeguard End");
	settings.SetToolTip("Lifeguard End", "Splits on leaving the boss room.");
	
	settings.Add("Button 1");
	settings.SetToolTip("Button 1", "Splits on re-entering the elevator.");
	
	settings.Add("Button 4");
	settings.SetToolTip("Button 4", "Splits on re-entering the elevator.");
	
	settings.Add("Button 7");
	settings.SetToolTip("Button 7", "Splits on re-entering the elevator.");
	
	settings.Add("Fall Back Down");
	settings.SetToolTip("Fall Back Down", "Splits on skipping the final dialogue of Satan.");
}

start
{
	if (current.CheckpointToLoad == "A.0" && old.CheckpointToLoad != "A.0"){
		return true;
	}
}

split
{
	//These are the splits based on room entry. Feel free to add more as required.
	if (old.levelName == "A.6" && current.levelName == "A.8 Checkpoint" && settings["Tutorial Exit"]){
		return true;
	}
	if (old.levelName == "A.18" && current.levelName == "R.0"&& settings["Storage Exit"]){
		return true;
	}
	if (old.levelName == "R.2" && current.levelName == "K.1"&& settings["Kitchen Entry"]){
		return true;
	}
	if (old.levelName == "K.7_2" && current.levelName == "K.BossRoom"&& settings["Beelzbub Start"]){
		return true;
	}
	if (old.levelName == "K.BossRoom" && current.levelName == "R.0"&& settings["Beelzbub End"]){
		return true;
	}
	if (old.levelName == "J.16" && current.levelName == "J.Boss"&& settings["Lifeguard Start"]){
		return true;
	}
	if (old.levelName == "J.Boss" && current.levelName == "J.Puerta"&& settings["Lifeguard End"]){
		return true;
	}
	if (old.levelName == "H.1" && current.levelName == "H.Ascensor"&& settings["Button 1"]){
		return true;
	}
	if (old.levelName == "H.13" && current.levelName == "H.Ascensor"&& settings["Button 4"]){
		return true;
	}
	if (old.levelName == "H.17" && current.levelName == "H.Ascensor"&& settings["Button 7"]){
		return true;
	}
	//logic for the final split
	if (current.levelName == "H.AscensorFinal" && current.CheckpointToLoad == "Satan" && current.InDialogue && !old.InDialogue){
		if (vars.firstElevatorDialogue && !vars.secondElevatorDialogue){
			vars.secondElevatorDialogue = true;
		}
		if (!vars.firstElevatorDialogue){
			vars.firstElevatorDialogue = true;
		} 
	}
	if (current.levelName == "H.AscensorFinal" && current.CurrentDemonCanMove && !old.CurrentDemonCanMove && vars.secondElevatorDialogue){
		if (settings["Fall Back Down"]){
			return true;
		}
		vars.firstElevatorDialogue = false;
		vars.secondElevatorDialogue = false;
	}
	//print(current.InDialogue.ToString());
	//print(current.CurrentDemonCanMove.ToString());
}

isLoading
{
	if (current.levelName == "H.AscensorFinal"){
		return false;
	}
	if (current.LoadingLevel){
		return true;
	}
	if (current.CurrentDemonCanMove){
		return false;
	}
}
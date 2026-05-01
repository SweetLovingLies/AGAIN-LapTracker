enum Route: Hashable {
	case reflection(selectedMood: Mood)
	case seedGet(entry: MoodEntry)
	case garden
	case wateringTransition(seed: MoodEntry)
}
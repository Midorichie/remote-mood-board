# Remote Mood Board

A decentralized mood tracking application built on the Stacks blockchain using Clarity smart contracts.

## Phase 2 Updates

### 🐛 Bug Fixes
- Fixed undefined `entries` variable in `add-mood` function
- Corrected map structure and data access patterns
- Fixed missing error handling and assertions
- Improved list operations and bounds checking

### 🔒 Security Enhancements
- Added contract owner authorization system
- Implemented emergency pause functionality (`toggle-contract-active`)
- Added comprehensive input validation and sanitization
- Enhanced error handling with specific error codes
- Added maximum entry limits and text length validation

### ✨ New Features
- **Mood Categories**: Added support for 7 different mood types (happy, sad, excited, calm, anxious, grateful, neutral)
- **User Statistics**: Track total entries and last entry timestamp per user
- **Global Analytics**: Total mood count across all users
- **Mood Analytics Contract**: Separate contract for advanced analytics and insights
- **Daily Mood Summaries**: Track mood patterns by date
- **User Streak Tracking**: Monitor consecutive days of mood logging
- **Weekly Insights**: Generate weekly mood trend reports

### 📊 Analytics Features
- Daily mood summaries with categorized counts
- User mood streaks (current and longest)
- Weekly trend analysis
- Mood category statistics
- Privacy-focused analytics (no personal data exposure)

## Contract Architecture

### Main Contract: `mood-board.clar`
- Core mood tracking functionality
- User mood entries with timestamps and IPFS CID support
- Mood categorization system
- User statistics tracking
- Security and access controls

### Analytics Contract: `mood-analytics.clar`
- Advanced analytics and insights
- Daily mood summaries
- User streak tracking
- Weekly trend analysis
- Owner-controlled analytics features

## Usage

### Adding a Mood Entry
```clarity
(contract-call? .mood-board add-mood 
  "Feeling great today!" 
  (some "QmYourIPFSHashHere") 
  "happy")
```

### Retrieving Your Moods
```clarity
(contract-call? .mood-board get-my-moods)
```

### Getting Analytics
```clarity
(contract-call? .mood-analytics get-my-streak)
(contract-call? .mood-analytics get-daily-summary u19000) ;; Example date
```

## Mood Categories
- `happy` - Joyful, content, positive emotions
- `sad` - Melancholy, down, negative emotions  
- `excited` - Energetic, enthusiastic, anticipatory
- `calm` - Peaceful, relaxed, serene
- `anxious` - Worried, stressed, nervous
- `grateful` - Thankful, appreciative, blessed
- `neutral` - Balanced, neither positive nor negative

## Security Features
- Contract owner controls for emergency situations
- Input validation and sanitization
- Rate limiting (max 100 entries per user)
- Text length limits (280 characters)
- Pausable contract functionality

## Data Privacy
- Users control their own mood data
- No personal information stored on-chain
- Optional IPFS integration for extended content
- Analytics are aggregated and anonymous

## Development

### Prerequisites
- Clarinet CLI
- Stacks blockchain knowledge
- Basic understanding of Clarity smart contracts

### Testing
```bash
clarinet test
```

### Deployment
```bash
clarinet deploy
```

## Roadmap
- [ ] Frontend web application
- [ ] Mobile app integration
- [ ] Advanced mood visualization
- [ ] Social features (mood sharing with friends)
- [ ] Mood-based NFT rewards
- [ ] Integration with health tracking apps

## Contributing
Please read our contributing guidelines and submit pull requests for any improvements.

## License
MIT License - see LICENSE file for details.

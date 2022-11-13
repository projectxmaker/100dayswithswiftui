# Project Flashzilla

In this project we’re going to build an app that helps users learn things using flashcards – cards with one thing written on such as “to buy”, and another thing written on the other side, such as “comprar”. Of course, this is a digital app so we don’t need to worry about “the other side”, and can instead just make the detail for the flash card appear when it’s tapped.

The name for this project is actually the name of my first ever app for iOS – an app I shipped so long ago it was written for iPhoneOS because the iPad hadn’t been announced yet. Apple actually rejected the app during app review because it had “Flash” in its product name, and at the time Apple were really keen to have Flash nowhere near their App Store! How times have changed…



# Challenges

1. When adding a card, the textfields keep their current text – fix that so that the textfields clear themselves after a card is added.

2. If you drag a card to the right but not far enough to remove it, then release, you see it turn red as it slides back to the center. Why does this happen and how can you fix it? (Tip: think about the way we set offset back to 0 immediately, even though the card hasn’t animated yet. You might solve this with a ternary within a ternary, but a custom modifier will be cleaner.)

3. For a harder challenge: when the users gets an answer wrong, add that card goes back into the array so the user can try it again. Doing this successfully means rethinking the ForEach loop, because relying on simple integers isn’t enough – your cards need to be uniquely identifiable.

4. Make it use documents JSON rather than UserDefaults – this is generally a good idea, so you should get practice with this.

5. Try to find a way to centralize the loading and saving code for the cards. You might need to experiment a little to find something you like!
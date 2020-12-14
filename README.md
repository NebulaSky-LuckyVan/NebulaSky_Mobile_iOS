# NebulaSky_Mobile_iOS

### 1.UIButton
UIButton

A control that executes your custom code in response to user interactions.
 



Creating Buttons
    + buttonWithType:
Creates and returns a new button of the specified type.
    + buttonWithType:primaryAction:
    - initWithFrame:
    - initWithFrame:primaryAction:
    - initWithCoder:
        
            
Specifies the style of a button.
Creating System Buttons
+ systemButtonWithImage:target:action:
Creates and returns a system type button with specified image, target, and action.
+ systemButtonWithPrimaryAction:
Configuring the Button Title
titleLabel
A view that displays the value of the currentTitle property for a button.
- titleForState:
Returns the title associated with the specified state.
- setTitle:forState:
Sets the title to use for the specified state.
- attributedTitleForState:
Returns the styled title associated with the specified state.
- setAttributedTitle:forState:
Sets the styled title to use for the specified state.
- titleColorForState:
Returns the title color used for a state.
- setTitleColor:forState:
Sets the color of the title to use for the specified state.
- titleShadowColorForState:
Returns the shadow color of the title used for a state.
- setTitleShadowColor:forState:
Sets the color of the title shadow to use for the specified state.
reversesTitleShadowWhenHighlighted
A Boolean value that determines whether the title shadow changes when the button is highlighted.
Configuring Button Presentation
adjustsImageWhenHighlighted
A Boolean value that determines whether the image changes when the button is highlighted.
adjustsImageWhenDisabled
A Boolean value that determines whether the image changes when the button is disabled.
showsTouchWhenHighlighted
A Boolean value that determines whether tapping the button causes it to glow.
- backgroundImageForState:
Returns the background image used for a button state.
- imageForState:
Returns the image used for a button state.
- setBackgroundImage:forState:
Sets the background image to use for the specified button state.
- setImage:forState:
Sets the image to use for the specified state.
- preferredSymbolConfigurationForImageInState:
Returns the preferred symbol configuration for a button state.
- setPreferredSymbolConfiguration:forImageInState:
Sets the preferred symbol configuration for a button state.
tintColor
The tint color to apply to the button title and image.
Configuring Edge Insets
contentEdgeInsets
The inset or outset margins for the rectangle surrounding all of the button’s content.
titleEdgeInsets
The inset or outset margins for the rectangle around the button’s title text.
imageEdgeInsets
The inset or outset margins for the rectangle around the button’s image.
Getting the Current State
buttonType
The button type.
currentTitle
The current title that is displayed on the button.
currentAttributedTitle
The current styled title that is displayed on the button.
currentTitleColor
The color used to display the title.
currentTitleShadowColor
The color of the title’s shadow.
currentImage
The current image displayed on the button.
currentBackgroundImage
The current background image displayed on the button.
currentPreferredSymbolConfiguration
The current symbol size, style, and weight.
imageView
The button’s image view.
Getting Dimensions
- backgroundRectForBounds:
Returns the rectangle in which the receiver draws its background.
- contentRectForBounds:
Returns the rectangle in which the receiver draws its entire content.
- titleRectForContentRect:
Returns the rectangle in which the receiver draws its title.
- imageRectForContentRect:
Returns the rectangle in which the receiver draws its image.
Supporting Pointer Interactions
pointerInteractionEnabled
A Boolean that enables pointer interaction.
pointerStyleProvider
The custom pointer style for a button.
UIButtonPointerStyleProvider
Specifying the Role
role
The role of the button.
UIButtonRole
Constants that describe the role of the button.
Customizing the Button Menu
menu
Deprecated Properties
font
The font used to display text on the button.
Deprecated
lineBreakMode
The line break mode to use when drawing text.
Deprecated
titleShadowOffset
The offset of the shadow used to display the receiver’s title.
Deprecated
Relationships
Inherits From
UIControl
Conforms To
NSCoding


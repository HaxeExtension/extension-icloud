# extension-icloud

An OpenFL extension that adds support for iCloud key-value storage on iOS.

## Usage

Synchronize with the server:
```haxe
ICloud.synchronize();
```

Note: `ICloud.synchronize()` can be called after setting a value to synchronize the key-value storage with the server in a timely manner, but is not required.

Register a function to call when the key-value storage changes:
```haxe
ICloud.onChange = function(reason:KeyValueStoreChangeReason, keys:Array<String>)
{
};

// ICloud.synchronize() needs to be called once to setup the callback
ICloud.synchronize();
```

Set a value in the key-value store:
```haxe
ICloud.setFloat("test float", 12.3);
ICloud.setInt("test int", 456);
ICloud.setString("test string", "hello world");
```

Retrieve a value from the key-value store:
```haxe
var testFloat = ICloud.getFloat("test float");
var testInt = ICloud.getInt("test int");
var testString = ICloud.getString("test string");
```

Deleting a value from the key-value store:
```haxe
ICloud.delete("test float");
ICloud.delete("test int");
ICloud.delete("test string");
```

### Simple usage example

In this example, the screen will change color each time the device is tapped. The color will persist across sessions on the same device as well as any other devices linked to the same account.

```haxe
import extension.icloud.ICloud;
import openfl.display.Sprite;
import openfl.events.TouchEvent;

using Lambda;

class ICloudExample extends Sprite
{
    public function new()
    {
        super();

        ICloud.onChange = onICloudChange;
        ICloud.synchronize();

        stage.color = ICloud.getInt("color");

        stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
    }
    
    function onICloudChange(reason:KeyValueStoreChangeReason, keys:Array<String>)
    {
        if (keys.has("color"))
        {
            stage.color = ICloud.getInt("color");
        }
    }

    function onTouchBegin(e:TouchEvent)
    {
        stage.color = generateRandomColor();

        ICloud.setInt("color", stage.color);
        ICloud.synchronize();
    }

    function generateRandomColor():Int
    {
        return (Math.round(Math.random() * 0xFF) << 16) +
               (Math.round(Math.random() * 0xFF) <<  8) +
                Math.round(Math.random() * 0xFF);
    }
}
```

## License

The MIT License (MIT) - [LICENSE.md](LICENSE.md)
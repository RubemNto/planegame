using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BloomToggle : MonoBehaviour
{
    public bool enableBloom = false;
    public BloomEffect bloomEffect;

    public void Click()
    {
        enableBloom = !enableBloom;
        bloomEffect.enabled = enableBloom;
    }
}

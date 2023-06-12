using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ColorBlindToggle : MonoBehaviour
{
    public string propertyName;
    public Material mat;
    public Toggle toggle;

    public void Click()
    {
        mat.SetInt(propertyName, toggle.isOn == true ? 1 : 0);
    }

    // public void ResetMaterial()
    // {
    //     mat.SetInt("_Normal", 0);
    //     mat.SetInt("_Achromatopsia", 0);
    //     mat.SetInt("_Tritanopia", 0);
    //     mat.SetInt("_Pratanopia", 0);
    //     mat.SetInt("_Deuteranopia", 0);
    // }

}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ColorBlindManager : MonoBehaviour
{
    public Material mat;
    public Toggle toggle;

    private void Awake()
    {
        ResetMaterial();
    }

    public void ResetMaterial()
    {
        if (toggle.isOn == false)
        {
            // mat.SetInt("_Normal", 0); // NOT REQUIRED TO RETURN TO NORMAL VISION
            mat.SetInt("_Achromatopia", 0);
            mat.SetInt("_Tritanopia", 0);
            mat.SetInt("_Pratanopia", 0);
            mat.SetInt("_Deuteranopia", 0);
        }
    }
}

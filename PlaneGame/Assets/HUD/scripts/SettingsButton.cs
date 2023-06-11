using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SettingsButton : MonoBehaviour
{
    public GameObject settings;
    private bool open;

    public bool affectTime;
    public Material mat;

    private void Start()
    {
        ResetMaterial();
    }

    public void Click()
    {
        open = !open;
        settings.SetActive(open);
        if (affectTime)
        {
            Time.timeScale = open == true ? 0.01f : 1;
        }
    }

    public void ResetMaterial()
    {
        mat.SetInt("_Achromatopia", 0);
        mat.SetInt("_Tritanopia", 0);
        mat.SetInt("_Pratanopia", 0);
        mat.SetInt("_Deuteranopia", 0);
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class HealthManager : MonoBehaviour
{
    [SerializeField]
    private int _hp;

    public int HP => _hp;

    public int maxHP;
    public int startHP;

    public Renderer[] renderers;
    private DamageVFXController m_VFXController;

    private void Start()
    {
        m_VFXController = GetComponentInChildren<DamageVFXController>();

        startHP = startHP > maxHP ? maxHP : startHP;
        startHP = startHP < 0 ? 0 : startHP;
        _hp = startHP;

        foreach (var rend in renderers)
        {
            rend.material.SetInt("_Toggle", 0);
        }
    }

    private void Update()
    {
        for (int i = 0; i < renderers.Length - _hp; i++)
        {
            renderers[i].material.SetInt("_Toggle", 1);
        }

        if (_hp <= 0)
        {
            //ADD EXPLOSION
            Destroy(gameObject);
            if (gameObject.tag == "Player")
            {
                SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
            }
        }
    }

    public void TakeHP(int value)
    {
        _hp = _hp - value < 0 ? 0 : _hp - value;

        if (m_VFXController)
        {
            float totalDamage = 1 - (float)_hp / maxHP;
            m_VFXController.UpdateDamageAmount(totalDamage);
        }

    }
    public void AddHP(int value)
    {
        _hp = _hp + value > maxHP ? maxHP : _hp + value;
    }
}

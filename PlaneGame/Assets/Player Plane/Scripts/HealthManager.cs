using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealthManager : MonoBehaviour
{
    private int _hp;

    public int HP => _hp;

    public int maxHP;
    public int startHP;

    private DamageVFXController m_VFXController;

    private void Start()
    {
        m_VFXController = GetComponentInChildren<DamageVFXController>();

        startHP = startHP > maxHP ? maxHP : startHP;
        startHP = startHP < 0 ? 0 : startHP;
        _hp = startHP;
    }

    private void Update()
    {
        if (_hp <= 0)
        {
            //ADD EXPLOSION
            Destroy(gameObject);
        }
    }

    public void TakeHP(int value)
    {
        _hp = _hp - value < 0 ? 0 : _hp - value;

        m_VFXController.UpdateDamageAmount((float)_hp / maxHP);
    }
    public void AddHP(int value)
    {
        _hp = _hp + value > maxHP ? maxHP : _hp + value;
    }
}

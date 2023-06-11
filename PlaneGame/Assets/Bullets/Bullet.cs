using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Enemy") || other.gameObject.CompareTag("Player"))
        {
            var HM = other.gameObject.GetComponent<HealthManager>();
            if (HM.HP > 0)
            {
                HM.TakeHP(1);
                //ADD FIRE EFFECT
            }
        }
        Destroy(gameObject);
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BulletController : MonoBehaviour
{
    public float moveSpeed;

    [Min(0)]
    public float destroyTime;

    private void Start()
    {
        Destroy(gameObject, destroyTime);
    }
    // Update is called once per frame
    void FixedUpdate()
    {
        transform.position += transform.forward * moveSpeed * Time.deltaTime;
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Gun : MonoBehaviour
{
    public GameObject bullet;
    public Transform bulletSpawn;
    public Vector2 minMaxHorizontalOffset;
    public Vector2 minMaxVerticalOffset;
    public float timeBetweenShots;
    private float _time;
    public KeyCode shootKey;

    public bool canShoot;
    public bool isAutomatic;

    private void Start()
    {
        _time = 0;
    }

    void CreateBullet()
    {
        Instantiate(bullet,
        bulletSpawn.position + new Vector3(
            Random.Range(minMaxHorizontalOffset.x, minMaxHorizontalOffset.y),
            Random.Range(minMaxVerticalOffset.x, minMaxVerticalOffset.y),
            0),
            bulletSpawn.rotation);
    }

    private void Update()
    {
        if (canShoot)
        {
            if (isAutomatic)
            {
                if (_time <= 0)
                {
                    CreateBullet();
                    _time = timeBetweenShots;
                }
            }
            else
            {
                if (Input.GetKey(shootKey))
                {
                    if (_time <= 0)
                    {
                        CreateBullet();
                        _time = timeBetweenShots;
                    }
                }
                else
                {
                    _time = 0;
                }
            }
            _time -= Time.deltaTime;
        }
    }
}

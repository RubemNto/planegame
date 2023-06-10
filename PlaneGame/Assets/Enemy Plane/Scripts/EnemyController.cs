using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyController : MonoBehaviour
{
    public CharacterController controller;
    public float maxSpeed;
    public float acceleration;
    // private Transform _target;
    private Vector3 _velocity;

    private void Start()
    {
        _velocity = Vector3.zero;
        // _target = GameObject.FindGameObjectsWithTag("Player")[0].transform;
    }

    // Update is called once per frame
    void Update()
    {
        // transform.LookAt(_target);

        Vector3 input = transform.forward;
        _velocity += input * acceleration * Time.deltaTime;

        if (_velocity.magnitude > maxSpeed)
        {
            _velocity = _velocity.normalized * maxSpeed;
        }

        controller.Move(_velocity * Time.deltaTime);
    }

}

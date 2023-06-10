using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    public CharacterController controller;
    public float maxSpeed;
    public float acceleration;
    private Vector2 _velocity;

    private float _horizontal;
    private float _vertical;

    public float maxMinPitch;
    public float maxMinRoll;
    public Vector2 _pitchRoll;

    private void Start()
    {
        _velocity = Vector2.zero;
        _pitchRoll = Vector2.zero;
    }

    private void Update()
    {
        _horizontal = Input.GetAxisRaw("Horizontal");
        _vertical = Input.GetAxisRaw("Vertical");

        if (_horizontal != 0 || _vertical != 0)
        {
            _pitchRoll += new Vector2(
                _horizontal * maxMinPitch * Time.deltaTime,
                _vertical * maxMinRoll * Time.deltaTime);

            if (_pitchRoll.x > maxMinPitch)
            {
                _pitchRoll = new Vector2(maxMinPitch, _pitchRoll.y);
            }
            else if (_pitchRoll.x < -maxMinPitch)
            {
                _pitchRoll = new Vector2(-maxMinPitch, _pitchRoll.y);
            }

            if (_pitchRoll.y > maxMinRoll)
            {
                _pitchRoll = new Vector2(_pitchRoll.x, maxMinRoll);
            }
            else if (_pitchRoll.y < -maxMinRoll)
            {
                _pitchRoll = new Vector2(_pitchRoll.x, -maxMinRoll);
            }
        }
        else
        {
            if (_vertical == 0)
            {
                // if (Mathf.Abs(_pitchRoll.y) > 0.1 && Mathf.Abs(_pitchRoll.y) < 0.15) { _pitchRoll = new Vector2(_pitchRoll.x, 0); }
                // else
                // {
                _pitchRoll -= new Vector2(0, (_pitchRoll.y > 0 ? Time.deltaTime : -Time.deltaTime) * 10);
                //}
            }
            if (_horizontal == 0)
            {
                // if (Mathf.Abs(_pitchRoll.x) > 0.1 && Mathf.Abs(_pitchRoll.x) < 0.15) { _pitchRoll = new Vector2(0, _pitchRoll.y); }
                // else
                // {
                _pitchRoll -= new Vector2(10 * (_pitchRoll.x > 0 ? Time.deltaTime : -Time.deltaTime), 0);
                //}
            }
        }

        if (Mathf.Abs(_pitchRoll.y) > 0 && Mathf.Abs(_pitchRoll.y) < 0.5) { _pitchRoll = new Vector2(_pitchRoll.x, 0); }
        if (Mathf.Abs(_pitchRoll.x) > 0 && Mathf.Abs(_pitchRoll.x) < 0.5) { _pitchRoll = new Vector2(0, _pitchRoll.y); }

        transform.rotation = Quaternion.Euler(-_pitchRoll.y, 0, -_pitchRoll.x);
    }

    void FixedUpdate()
    {
        Vector2 input = new Vector2(_horizontal, _vertical);

        if (input.magnitude != 0)
        {
            input = input.normalized;

            _velocity += input * acceleration * Time.deltaTime;

            if (_velocity.magnitude > maxSpeed)
            {
                _velocity = _velocity.normalized * maxSpeed;
            }
        }
        else
        {
            _velocity -= _velocity.normalized * 2 * acceleration * Time.deltaTime;
            if (Mathf.Abs(_velocity.x) > 0.05 && Mathf.Abs(_velocity.x) < 0.1) { _velocity = new Vector2(0, _velocity.y); }
            if (Mathf.Abs(_velocity.y) > 0.05 && Mathf.Abs(_velocity.y) < 0.1) { _velocity = new Vector2(_velocity.x, 0); }
        }


        controller.Move(_velocity * Time.deltaTime);
    }
}

import React from 'react'
import {render} from 'react-dom'
import axios from 'axios';
//import App from './App'
import { PlusCircle } from 'react-feather';



class AddButton extends React.Component{
  constructor(props) {
      super(props);
      this.state = {input: [{0: null}]}; //key is string even without ""
      this.deleteIdx = -1
      // This binding is necessary to make `this` work in the callback
      this.handleAdd = this.handleAdd.bind(this);
      this.handleDelete = this.handleDelete.bind(this);
    }    

    handleAdd() {

      var form_array = this.state.input.slice()
      const current_index = parseInt(Object.keys(form_array)[form_array.length-1])+1
      form_array.push({[current_index]:null})

      this.setState(
        (state)=>({input: form_array})
      );
    }

    handleDelete(event) {
      var form_array = this.state.input.slice()
      for (let i of form_array){
        let _key = Object.keys(i)[0]
        console.log("_key " + _key)
        console.log("key " + event.target.key)
        if (_key == event.target.key){
          const index = form_array.indexOf(i);
          form_array.splice(index, 1);
          this.deleteIdx = index
          console.log("deleteIdx1 " + deleteIdx)
          break
        }
      }
      this.setState(
        (state)=>({input: form_array})
      );
      
    }

    render() {
      console.log("ja2")
      return (
        <div>
          <button onClick={this.handleAdd}>
          {this.state.input.length}
          </button>

          <MahnungForm action_signal={this.state.input[this.state.input.length-1]} getKey={this.handleDelete} deleteIdx={this.deleteIdx}></MahnungForm>
        </div>
      );
    }
}

class MahnungForm extends React.Component{
  constructor(props) {
      super(props);
      this.state = {formtables:[]} //wrapper MahnungTable
      //this.handleAction = this.handleAction.bind(this)
    }    

    handleAction(){
      const action_signal = parseInt(Object.keys(this.props.action_signal)[0]) //if > 0 is add <0 is remove
      console.log("action_signal " + action_signal)
      const max_index = (this.state.length) > 0 ? parseInt(Object.keys(this.state[this.state.length-1])[0]) : 0
      console.log("max_index " + max_index)
      var tables = (this.state.formtables.length) > 0 ? this.state.formtables.slice() : []
      console.log("s1")
      if (action_signal > max_index) {
        console.log("s2")
        tables.push(<MahnungTable key={action_signal} getKey={this.props.getKey} />)
        console.log("s3")
        this.setState(
          (state)=>({formtables:tables})
        );
        console.log("s4")
        console.log("deleteIdx2 " + this.props.deleteIdx)
        console.log(this.state.formtables)
      } else if (action_signal == max_index && max_index > 0){
          const index = this.props.deleteIdx
          if (index != -1){
            tables.splice(index, 1);
            this.setState(
              (state)=>({formtables:tables})
            );
          }
          
      }
    } 

    render() {

      this.handleAction()


      //problem
      return (
        <fragment>
          <table>
            <tr>
              <th>Pos</th>
              <th>Content</th>
            </tr>
          </table>
          <form>
          <ul>
          {this.state.formtables}
          </ul>
          <input type="submit" value="Submit" />
          </form>
        </fragment>
      );
    }
}

class MahnungTable extends React.Component{
  constructor(props) {
      super(props);
    }    


    render() {
      console.log("s5")
      return (
        <li>
          <label>
            Name:
            <input type="text" name="name" />
          </label>
          <button key={this.props.key} onClick={this.props.getKey}>
            löschen
          </button>
        </li>

      );

    }
}
render(<AddButton />,document.getElementById('root'))